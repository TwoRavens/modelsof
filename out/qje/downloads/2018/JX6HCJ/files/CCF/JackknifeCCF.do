

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	if ("`absorb'" == "") `anything' `if' `in', cluster(`cluster') `robust'
	if ("`absorb'" ~= "") `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
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
		if ("`absorb'" == "") quietly `anything' if M ~= `i', cluster(`cluster') `robust'
		if ("`absorb'" ~= "") quietly `anything' if M ~= `i', cluster(`cluster') `robust' absorb(`absorb')
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


global cluster = "billid"

global i = 1
global j = 1

use DatCCF1, clear

*Tables 3 & 5
mycmd (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid) 
mycmd (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2-sited4 if date >= 23, absorb(name) cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named235 sited2-sited4 if date >= 23, cluster(billid)
mycmd (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2-sited4, absorb(name) cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named235 sited2-sited4, cluster(billid)

**************************************

use DatCCF2, clear

*Table 4 & 6
mycmd (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2 if date >= 23, absorb(name) cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named115 sited2 if date >= 23, cluster(billid)
mycmd (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2, absorb(name) cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named115 sited2, cluster(billid)

use ip\JK1, clear
forvalues i = 2/16 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/16 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeCCF, replace

