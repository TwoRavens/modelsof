
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
		matrix F[$ii,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$jj+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global ii = $ii + 1
global jj = $jj + $k
end

****************************************
****************************************

use DatFG1, clear

matrix F = J(10,4,.)
matrix B = J(13,2,.)

global ii = 1
global jj = 1

mycmd (high) areg totrev high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high exp block2 block3, absorb(fahrer) cluster(fahrer) 
mycmd (high) areg shifts high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high exp block2 block3, absorb(fahrer) cluster(fahrer)


**********************************
 
use DatFG2, clear

*Table 5 
mycmd (high) areg lnum high lnten female, absorb(datum) cluster(datum) 
mycmd (high) areg lnum high lnten fdum*, absorb(datum) cluster(datum) 

*Table 6 
mycmd (high_la high_not0) areg lnum high_la high_not0 lnten fdum*, absorb(datum) cluster(datum) 
mycmd (high_la1 high_la2 high_not0) areg lnum high_la1 high_la2 high_not0 lnten fdum*, absorb(datum) cluster(datum) 

****************************************
****************************************

use DatFG1, clear

global i = 0

gen Strata = (odd ~= .)
replace odd = 2 if odd == .

*Coding odd for fahrer 10 in a fashion consistent with odd measure in other file (see Replication & FisherNFG)
*Randomize reproducing systematic errors (fahrer 10, high == 0)

quietly replace odd = 0 if fahrer == 10
global calc = "calc1(replace high = 0) calc2(replace high = 1 if odd + block == 3 & odd <= 1) calc3(replace high = 0 if fahrer == 10)"

global i = $i + 1
	randcmdc ((high) areg totrev high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)), treatvars(odd) seed(1) saving(ip\a$i, replace) strata(Strata) reps($reps) sample groupvar(fahrer) $calc
global i = $i + 1
	randcmdc ((high) areg totrev high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)), treatvars(odd) seed(1) saving(ip\a$i, replace) strata(Strata) reps($reps) sample groupvar(fahrer) $calc
global i = $i + 1
	randcmdc ((high) areg totrev high exp block2 block3, absorb(fahrer) cluster(fahrer)), treatvars(odd) seed(1) saving(ip\a$i, replace) strata(Strata) reps($reps) sample groupvar(fahrer) $calc
global i = $i + 1
	randcmdc ((high) areg shifts high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)), treatvars(odd) seed(1) saving(ip\a$i, replace) strata(Strata) reps($reps) sample groupvar(fahrer) $calc
global i = $i + 1
	randcmdc ((high) areg shifts high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)), treatvars(odd) seed(1) saving(ip\a$i, replace) strata(Strata) reps($reps) sample groupvar(fahrer) $calc
global i = $i + 1
	randcmdc ((high) areg shifts high exp block2 block3, absorb(fahrer) cluster(fahrer)), treatvars(odd) seed(1) saving(ip\a$i, replace) strata(Strata) reps($reps) sample groupvar(fahrer) $calc


**********************************
 
use DatFG2, clear

*First, code odd for missing odd in a fashion consistent with their high coding
replace odd = 0 if odd == .
*Randomize reproducing systematic coding errors
global calc = "calc1(replace high = 0) calc2(replace high = 1 if odd + block == 3 & t ~= 29)"

*Table 5 
global i = $i + 1
	randcmdc ((high) areg lnum high lnten female, absorb(datum) cluster(datum) ), treatvars(odd) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(fahrer) $calc

global i = $i + 1
	randcmdc ((high) areg lnum high lnten fdum*, absorb(datum) cluster(datum) ), treatvars(odd) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(fahrer) $calc


*Table 6 
forvalues j = 1/5 {
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
save results\FisherCondFG, replace



