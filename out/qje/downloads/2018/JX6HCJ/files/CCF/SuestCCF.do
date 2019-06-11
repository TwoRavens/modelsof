
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xxx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xxx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xxx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************


use DatCCF1, clear

matrix B = J(32,2,.)
global j = 1

*Tables 3
global i = 0
mycmd (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid) 
mycmd (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2-sited4 if date >= 23, absorb(name) cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named235 sited2-sited4 if date >= 23, cluster(billid)

quietly suest $M, cluster(billid)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

*Table 5
global i = 0
mycmd (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2-sited4, absorb(name) cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named235 sited2-sited4, cluster(billid)

quietly suest $M, cluster(billid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

**************************************

use DatCCF2, clear

*Table 4
global i = 0
mycmd (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2 if date >= 23, absorb(name) cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named115 sited2 if date >= 23, cluster(billid)

quietly suest $M, cluster(billid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

*Table 6
global i = 0
mycmd (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2, absorb(name) cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named115 sited2, cluster(billid)

quietly suest $M, cluster(billid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

drop _all
svmat double F
svmat double B
save results/SuestCCF, replace






