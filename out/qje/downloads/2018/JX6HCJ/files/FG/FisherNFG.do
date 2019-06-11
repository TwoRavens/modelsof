
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') absorb(`absorb')
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
	syntax anything [if] [in] [, absorb(string) cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster') absorb(`absorb')
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

*Preparing treatment vector
*Some confusion in data file:  fahrer 7 and 10 do not have "odd" (treatment) value in tables5to6 file.
*But, they are both listed as having received treatment at some point in that file (check maxhigh & high)
*This does not affect those regressions since odd is not used
*Their coding of high indicates odd was actually 0.
*In sum, their treatment is not coded (odd == .) but data file is consistent with treatment odd == 0

*In tables1to4, individual 7 has odd value, but individual 10 does not.
*In this table, individual 10 listed as always not treated, (i.e. neither odd 1 nor 0) even though indicated as treated in tables5to6.
*When I randomize treatment (using full treatment vector for all individuals involved in experiment)
*will set individual 10 as always not treated whatever their odd outcome in the randomization
*This is consistent with the coding error in the file

*There is also a coding error in tables5to6 with regard to whether high occurs for odd on a particular date 
*Will reproduce this coding error as well


use DatFG1, clear

matrix F = J(6,4,.)
matrix B = J(6,2,.)

global i = 1
global j = 1

mycmd (high) areg totrev high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high exp block2 block3, absorb(fahrer) cluster(fahrer) 
mycmd (high) areg shifts high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high exp block2 block3, absorb(fahrer) cluster(fahrer)

global N = 43
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y1")

mata ResF = J($reps,6,.); ResD = J($reps,6,.); ResDF = J($reps,6,.); ResB = J($reps,6,.); ResSE = J($reps,6,.)
forvalues c = 1/$reps {
	matrix FF = J(6,3,.)
	matrix BB = J(6,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y1",Y)
	forvalues i = 1/$N {
		quietly replace odd = Y1[`i'] if fahrer == Y2[`i']
		}
	quietly replace high = 0
	quietly replace high = 1 if odd + block == 3
*Reproducing systematic coding error
	quietly replace high = 0 if fahrer == 10


global i = 1
global j = 1

mycmd1 (high) areg totrev high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd1 (high) areg totrev high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd1 (high) areg totrev high exp block2 block3, absorb(fahrer) cluster(fahrer) 
mycmd1 (high) areg shifts high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd1 (high) areg shifts high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd1 (high) areg shifts high exp block2 block3, absorb(fahrer) cluster(fahrer)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..6] = FF[.,1]'; ResD[`c',1..6] = FF[.,2]'; ResDF[`c',1..6] = FF[.,3]'
mata ResB[`c',1..6] = BB[.,1]'; ResSE[`c',1..6] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/6 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherFG1, replace

**********************************
 
use DatFG2, clear

matrix F = J(4,4,.)
matrix B = J(7,2,.)

global i = 1
global j = 1

*Table 5 
mycmd (high) areg lnum high lnten female, absorb(datum) cluster(datum) 
mycmd (high) areg lnum high lnten fdum*, absorb(datum) cluster(datum) 

*Table 6 
mycmd (high_la high_not0) areg lnum high_la high_not0 lnten fdum*, absorb(datum) cluster(datum) 
mycmd (high_la1 high_la2 high_not0) areg lnum high_la1 high_la2 high_not0 lnten fdum*, absorb(datum) cluster(datum) 

*Actually none of the conditionals in the regressions matter, as satisfied for all observations

global N = 43
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y1")
replace odd = 0 if odd == .

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,7,.); ResSE = J($reps,7,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(7,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y1",Y)
	forvalues i = 1/$N {
		quietly replace odd = Y1[`i'] if fahrer == Y2[`i']
		}
	quietly replace high = 0
	quietly replace high = 1 if odd + block == 3 & t ~= 29
	foreach i in la la1 la2 not0 {
		quietly replace high_`i' = high*`i'
		}

global i = 1
global j = 1

*Table 5 
mycmd1 (high) areg lnum high lnten female, absorb(datum) cluster(datum) 
mycmd1 (high) areg lnum high lnten fdum*, absorb(datum) cluster(datum) 

*Table 6 
mycmd1 (high_la high_not0) areg lnum high_la high_not0 lnten fdum*, absorb(datum) cluster(datum) 
mycmd1 (high_la1 high_la2 high_not0) areg lnum high_la1 high_la2 high_not0 lnten fdum*, absorb(datum) cluster(datum) 

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..7] = BB[.,1]'; ResSE[`c',1..7] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 7/10 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 7/13 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherFG2, replace

**********************************


use ip\FisherFG2, clear
mkmat F1-F4 in 1/4, matrix(F2)
mkmat B1-B2 in 1/7, matrix(B2)
drop F1-F4 B1 B2 
sort N
save a, replace

use ip\FisherFG1, clear
mkmat F1-F4 in 1/6, matrix(F1)
mkmat B1-B2 in 1/6, matrix(B1)
drop F1-F4 B1 B2 
sort N
merge N using a
tab _m
drop _m
sort N
aorder
matrix F = F1 \ F2
matrix B = B1 \ B2
svmat double B
svmat double F
save results\FisherFG, replace


capture erase a.dta






