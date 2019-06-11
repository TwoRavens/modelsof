
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		`anything' `if' `in', cluster(`cluster') absorb(`absorb')
		}
	else {
		`anything' `if' `in', cluster(`cluster') 
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
	syntax anything [if] [in] [, cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		quietly `anything' `if' `in', cluster(`cluster') absorb(`absorb')
		}
	else {
		quietly `anything' `if' `in', cluster(`cluster') 
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

use DatCCF1, clear

matrix F = J(8,4,.)
matrix B = J(16,2,.)

global i = 1
global j = 1

*Tables 3 & 5
mycmd (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid) 
mycmd (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2-sited4 if date >= 23, absorb(name) cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named235 sited2-sited4 if date >= 23, cluster(billid)
mycmd (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2-sited4, absorb(name) cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named235 sited2-sited4, cluster(billid)

egen Unit = group(group th table)
bysort Unit: gen N = _n
sort N group Unit
global N = 273
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"treat")

mata ResF = J($reps,8,.); ResD = J($reps,8,.); ResDF = J($reps,8,.); ResB = J($reps,16,.); ResSE = J($reps,16,.)
forvalues c = 1/$reps {
	matrix FF = J(8,3,.)
	matrix BB = J(16,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N group U in 1/$N
	mata st_store((1,$N),"treat",Y)
	sort Unit N
	quietly replace treat = treat[_n-1] if Unit == Unit[_n-1] & N > 1
	quietly replace treattop5 = treat*top5
	quietly replace treatafter = treat*after
	quietly replace treattop5after = treatafter*top5
global i = 1
global j = 1

*Tables 3 & 5
mycmd1 (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid) 
mycmd1 (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2-sited4 if date >= 23, absorb(name) cluster(billid)
mycmd1 (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd1 (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named235 sited2-sited4 if date >= 23, cluster(billid)
mycmd1 (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd1 (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2-sited4, absorb(name) cluster(billid)
mycmd1 (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd1 (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named235 sited2-sited4, cluster(billid)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..8] = FF[.,1]'; ResD[`c',1..8] = FF[.,2]'; ResDF[`c',1..8] = FF[.,3]'
mata ResB[`c',1..16] = BB[.,1]'; ResSE[`c',1..16] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/8 {
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
save ip\FisherCCF1, replace


**************************************

use DatCCF2, clear

matrix F = J(8,4,.)
matrix B = J(16,2,.)

global i = 1
global j = 1

*Table 4 & 6
mycmd (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2 if date >= 23, absorb(name) cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named115 sited2 if date >= 23, cluster(billid)
mycmd (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2, absorb(name) cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named115 sited2, cluster(billid)

egen Unit = group(group th table)
bysort Unit: gen N = _n
sort N group Unit
global N = 70
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"treat")

mata ResF = J($reps,8,.); ResD = J($reps,8,.); ResDF = J($reps,8,.); ResB = J($reps,16,.); ResSE = J($reps,16,.)
forvalues c = 1/$reps {
	matrix FF = J(8,3,.)
	matrix BB = J(16,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N group U in 1/$N
	mata st_store((1,$N),"treat",Y)
	sort Unit N
	quietly replace treat = treat[_n-1] if Unit == Unit[_n-1] & N > 1
	quietly replace treattop5 = treat*top5
	quietly replace treatafter = treat*after
	quietly replace treattop5after = treatafter*top5

global i = 1
global j = 1

*Table 4 & 6
mycmd1 (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd1 (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2 if date >= 23, absorb(name) cluster(billid)
mycmd1 (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd1 (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named115 sited2 if date >= 23, cluster(billid)
mycmd1 (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd1 (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2, absorb(name) cluster(billid)
mycmd1 (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd1 (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named115 sited2, cluster(billid)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..8] = FF[.,1]'; ResD[`c',1..8] = FF[.,2]'; ResDF[`c',1..8] = FF[.,3]'
mata ResB[`c',1..16] = BB[.,1]'; ResSE[`c',1..16] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/8 {
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
save ip\FisherCCF2, replace

********************************

*Combining files

use ip\FisherCCF2, clear
mkmat F1-F4 in 1/8, matrix(FF)
mkmat B1 B2 in 1/16, matrix(BB)
forvalues i = 8(-1)1 {
	local j = `i' + 8
	rename ResF`i' ResF`j'
	rename ResDF`i' ResDF`j'
	rename ResD`i' ResD`j'
	}
forvalues i = 16(-1)1 {
	local j = `i' + 16
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
drop F1-F4 B1 B2 
sort N
save aa, replace

use ip\FisherCCF1, clear
mkmat F1-F4 in 1/8, matrix(F)
mkmat B1 B2 in 1/16, matrix(B)
matrix F = F \ FF
matrix B = B \ BB
drop F1-F4 B1 B2 
sort N
merge N using aa
tab _m
drop _m
sort N
svmat double F
svmat double B
aorder
save results\FisherCCF, replace
















