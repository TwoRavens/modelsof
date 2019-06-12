

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust ll hc3 vce(string)]
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust' `hc3' `ll' vce(`vce')
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
		quietly `anything' if M ~= `i', cluster(`cluster') `robust' `hc3' `ll' vce(`vce') 
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


global cluster = ""
global j = 1
global i = 1

use DatLMW, clear

*Table 1
mycmd (sorting) reg percshared sorting , hc3
mycmd (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, hc3
mycmd (sorting) tobit percshared sorting , ll vce(jackknife)
mycmd (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll vce(jackknife)	
mycmd (sorting) probit percshared sorting , robust
mycmd (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, robust

*Table 2
mycmd (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, hc3


use ip\JK1, clear
forvalues i = 2/7 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/7 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeLMW, replace

use results\JackknifeLMW, clear
gen double ResB11 = ResB1
gen double ResSE11 = ResSE1
foreach var in ResF ResD ResDF {
	gen double `var'8 = `var'1
	}
quietly replace B1 = B1[1] if _n == 11
quietly replace B2 = B2[1] if _n == 11
aorder
save results\JackknifeLMW, replace


