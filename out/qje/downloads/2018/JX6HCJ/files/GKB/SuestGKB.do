
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* xxx* Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
	quietly generate Ssample$i = e(sample)
	quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
	quietly predict double yyy$i if Ssample$i, resid
	local newtestvars = ""
	foreach var in `testvars' {
		quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
		quietly predict double xxx`var'$i if Ssample$i, resid
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	quietly reg yyy$i `newtestvars', noconstant
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


use DatGKB, clear

matrix B = J(75,2,.)
global j = 1

global covariates "MBfemale Mreportedage MZBfemale MZreportedage MZBvoted2004 MZBvoted2002 MZBvoted2001 MZBconsumer MZBgetsmag MZBpreferrepub MZBprefernoone MZwave2"
global priorvoting = "voted2004g voted2003g voted2002g voted2001g voted2000g"

*TABLE 2
global i = 0
foreach X in getapaper getpost gettimes readfrqr readsome {
	mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
	mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells)
	}
quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

*TABLE 3
global i = 0
foreach X in factindex consindexpol consindexgen {
	mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
	mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells)
	}
quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)
	
*TABLE 4
global i = 0
foreach X in voted voted2005g voted2006g voteddem voteddem_all {
	if ("`X'" == "voted2005g" | "`X'" == "voted2006g" ) {
		mycmd (post times) areg `X' post times $covariates $priorvoting if completematch=="yes", absorb(cells)
		}
	else {
		mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
		}
	if ("`X'" == "voted2005g" | "`X'" == "voted2006g" ) {
		mycmd (paper) areg `X' paper $covariates $priorvoting if completematch=="yes", absorb(cells)
		}
	else {
		mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells)
		}
	}
quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

*APPENDIX TABLE 2
global i = 0
foreach X in iraqdead libby miers mostimp_scandals iraq_post iraq leak alito repfavorable demunfavorable bushapproval conservative {
	mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
	mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells) 
	}
quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 102)

drop _all
svmat double F
svmat double B
save results/SuestGKB, replace






