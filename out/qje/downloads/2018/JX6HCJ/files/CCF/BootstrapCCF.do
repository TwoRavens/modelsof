
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	if ("`absorb'" ~= "") {
		`anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
		}
	else {
		`anything' `if' `in', cluster(`cluster') `robust'
		}
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	forvalues i = 1/$reps {
		set seed `i'
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse', cluster($cluster) idcluster(`newcluster')
			if ("`absorb'" ~= "") {
				capture `anything', cluster(`newcluster') `robust' absorb(`absorb')
				}
			else {
				capture `anything', cluster(`newcluster') `robust'
				}
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

********************************************

use ip\BS1, clear
forvalues i = 2/16 {
	merge using ip\BS`i'
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
save results\BootstrapCCF, replace

