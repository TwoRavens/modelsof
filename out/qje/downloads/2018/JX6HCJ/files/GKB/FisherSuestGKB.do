

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
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatGKB, clear

global covariates "MBfemale Mreportedage MZBfemale MZreportedage MZBvoted2004 MZBvoted2002 MZBvoted2001 MZBconsumer MZBgetsmag MZBpreferrepub MZBprefernoone MZwave2"
global priorvoting = "voted2004g voted2003g voted2002g voted2001g voted2000g"

*TABLE 2
global i = 0
foreach X in getapaper getpost gettimes readfrqr readsome {
	mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
	if ("`X'" ~= "getapaper" & "`X'" ~= "gettimes" & "`X'" ~= "readsome") mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells)
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
	if ("`X'" == "voted2005g") {
		mycmd (paper) areg `X' paper $covariates $priorvoting if completematch=="yes", absorb(cells)
		}
	else if ("`X'" ~= "voted2006g") {
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

generate N = _n
sort cells N
generate Order = _n
generate double U = .
mata Y = st_data(.,("treatment","post","times","paper"))

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort cells U
	mata st_store(.,("treatment","post","times","paper"),Y)

*TABLE 2
global i = 0
foreach X in getapaper getpost gettimes readfrqr readsome {
	mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
	if ("`X'" ~= "getapaper" & "`X'" ~= "gettimes" & "`X'" ~= "readsome") mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells)
	}
capture suest $M, robust
if (_rc == 0) {
	capture test $test 
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
		}
	}

*TABLE 3
global i = 0
foreach X in factindex consindexpol consindexgen {
	mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
	mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells)
	}
capture suest $M, robust
if (_rc == 0) {
	capture test $test 
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}
	
*TABLE 4
global i = 0
foreach X in voted voted2005g voted2006g voteddem voteddem_all {
	if ("`X'" == "voted2005g" | "`X'" == "voted2006g" ) {
		mycmd (post times) areg `X' post times $covariates $priorvoting if completematch=="yes", absorb(cells)
		}
	else {
		mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
		}
	if ("`X'" == "voted2005g") {
		mycmd (paper) areg `X' paper $covariates $priorvoting if completematch=="yes", absorb(cells)
		}
	else if ("`X'" ~= "voted2006g") {
		mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells)
		}
	}
capture suest $M, robust
if (_rc == 0) {
	capture test $test 
	if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

*APPENDIX TABLE 2
global i = 0
foreach X in iraqdead libby miers mostimp_scandals iraq_post iraq leak alito repfavorable demunfavorable bushapproval conservative {
	mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
	mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells) 
	}
capture suest $M, robust
if (_rc == 0) {
	capture test $test 
	if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 102)
		}
	}

}


drop _all
set obs $reps
forvalues i = 1/20 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save results\FisherSuestGKB, replace


