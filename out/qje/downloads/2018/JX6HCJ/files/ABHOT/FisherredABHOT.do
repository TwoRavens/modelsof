****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, absorb(string) cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "" & "`cluster'" ~= "") {
		`anything' [`weight' `exp'] `if' `in', absorb(`absorb') cluster(`cluster') `robust'
		}
	else if ("`absorb'" ~= "") {
		`anything' [`weight' `exp'] `if' `in', absorb(`absorb') `robust'
		}
	else {
		`anything' [`weight' `exp'] `if' `in', cluster(`cluster') `robust'
		}
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
	syntax anything [aw pw] [if] [in] [, absorb(string) cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "" & "`cluster'" ~= "") {
		quietly `anything' [`weight' `exp'] `if' `in', absorb(`absorb') cluster(`cluster') `robust'
		}
	else if ("`absorb'" ~= "") {
		quietly `anything' [`weight' `exp'] `if' `in', absorb(`absorb') `robust'
		}
	else {
		quietly `anything' [`weight' `exp'] `if' `in', cluster(`cluster') `robust'
		}
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

foreach file in 1 2 3a 3b 3 4 6 7 8 9 {
	use ip\FisherABHOT`file', clear
	save ip\FisherRedABHOT`file', replace
	}

**************************************

use DatABHOT5, clear

matrix F = J(4,4,.)
matrix B = J(6,2,.)

global i = 1
global j = 1
*Table 8
mycmd (random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB random_rank) areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

*Note last column doesn't include HYBRID (should, but doesn't).  If include doesn't match reported table - error in their code
*Note coefficient becomes insignificant when HYBRID is added, as in reported, but not used, specification
areg RTS random_rank random_rankHYB HYBRID, absorb(kecagroup) cluster(hhea)
*Note second column does include HYBRID.  If don't doesn't match table
areg MISTARGETDUMMY random_rank random_rankHYB, absorb(kecagroup) cluster(hhea)

sort hhea rank
mata YY = st_data(.,"rank")

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),"HYBRID")
generate double U = .
generate Order = _n

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,6,.); ResSE = J($reps,6,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(6,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N kecagroup U in 1/$N
	mata st_store((1,$N),"HYBRID",Y)
	sort hhea N
	quietly replace HYBRID = HYBRID[_n-1] if hhea == hhea[_n-1] & N > 1
	quietly replace U = uniform()
	sort hhea U
	mata st_store(.,"random_rank",YY)
	quietly replace random_rankHYB=random_rank*HYBRID

global i = 1
global j = 1
*Table 8
mycmd1 (random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (random_rankHYB random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (random_rankHYB random_rank) areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..6] = BB[.,1]'; ResSE[`c',1..6] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/6 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF,ResD,ResDF,ResB,ResSE))
svmat double F
svmat double B
gen N = _n
sort N
local file = "$file"
save ip\FisherRedABHOT5, replace


***************************************************

*Combining files

matrix count = (8,8,5,9,1,5,4,4,3,1,4) \ (16,64,10,18,3,31,6,8,13,5,20)

drop _all
use ip\FisherRedABHOT1
global k = count[2,1]
global N = count[1,1]
mkmat F1-F4 in 1/$N, matrix(F)
mkmat B1 B2 in 1/$k, matrix(B)

local c = 2
foreach j in 2 3a 3b 3 4 5 6 7 8 9 {
	use ip\FisherRedABHOT`j', clear
	sort N
	global k1 = count[2,`c']
	global N1 = count[1,`c']
	local c = `c' + 1
mkmat F1-F4 in 1/$N1, matrix(FF)
mkmat B1 B2 in 1/$k1, matrix(BB)
	matrix F = F \ FF
	matrix B = B \ BB
	drop F1-F4 B1-B2 
	forvalues i = $k1(-1)1 {
		local k = `i' + $k
		rename ResB`i' ResB`k'
		rename ResSE`i' ResSE`k'
		}
	forvalues i = $N1(-1)1 {
		local k = `i' + $N
		rename ResF`i' ResF`k'
		rename ResDF`i' ResDF`k'
		rename ResD`i' ResD`k'
		}
	global k = $k + $k1
	global N = $N + $N1
	save a`j', replace
	}

use ip\FisherRedABHOT1, clear
drop F1-F4 B1-B2 
foreach j in 2 3a 3b 3 4 5 6 7 8 9 {
	sort N
	merge N using a`j'
	tab _m
	drop _m
	sort N
	}
aorder
svmat double F
svmat double B
save results\FisherRedABHOT, replace

foreach j in 2 3a 3b 3 4 5 6 7 8 9 {
	capture erase a`j'.dta
	}


