
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', absorb(`absorb')
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

matrix F = J(50,4,.)
matrix B = J(75,2,.)

use DatGKB, clear

global covariates "MBfemale Mreportedage MZBfemale MZreportedage MZBvoted2004 MZBvoted2002 MZBvoted2001 MZBconsumer MZBgetsmag MZBpreferrepub MZBprefernoone MZwave2"
global priorvoting = "voted2004g voted2003g voted2002g voted2001g voted2000g"

global i = 1
global j = 1

*TABLE 2
foreach X in getapaper getpost gettimes readfrqr readsome {
	mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
	mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells)
	}

*TABLE 3
foreach X in factindex consindexpol consindexgen {
	mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
	mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells)
	}
	
*TABLE 4
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

*APPENDIX TABLE 2
foreach X in iraqdead libby miers mostimp_scandals iraq_post iraq leak alito repfavorable demunfavorable bushapproval conservative {
	mycmd (post times) areg `X' post times $covariates doperator*, absorb(cells)
	mycmd (paper) areg `X' paper $covariates doperator*, absorb(cells) 
	}

generate N = _n
sort cells N
generate Order = _n


global i = 0

*TABLE 2
foreach X in getapaper getpost gettimes readfrqr readsome {
	foreach var in post times {
		global i = $i + 1
		capture drop Strata
		gen Strata = (paper == 0 | `var' == 1) 
		randcmdc ((`var') areg `X' post times $covariates doperator*, absorb(cells)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	foreach var in paper {
		global i = $i + 1
		capture drop Strata
		gen Strata = (paper == 0 | `var' == 1) 
		randcmdc ((`var') areg `X' paper $covariates doperator*, absorb(cells)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	}

*TABLE 3
foreach X in factindex consindexpol consindexgen {
	foreach var in post times {
		global i = $i + 1
		capture drop Strata
		gen Strata = (paper == 0 | `var' == 1) 
		randcmdc ((`var') areg `X' post times $covariates doperator*, absorb(cells)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	foreach var in paper {
		global i = $i + 1
		capture drop Strata
		gen Strata = (paper == 0 | `var' == 1) 
		randcmdc ((`var') areg `X' paper $covariates doperator*, absorb(cells)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	}


*TABLE 4
foreach X in voted voted2005g voted2006g voteddem voteddem_all {
	foreach var in post times {
		global i = $i + 1
		capture drop Strata
		gen Strata = (paper == 0 | `var' == 1) 
		if ("`X'" == "voted2005g" | "`X'" == "voted2006g" ) {
			randcmdc ((`var') areg `X' post times $covariates $priorvoting if completematch=="yes", absorb(cells)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}
		else {
			randcmdc ((`var') areg `X' post times $covariates doperator*, absorb(cells)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}
		}
	foreach var in paper {
		global i = $i + 1
		capture drop Strata
		gen Strata = (paper == 0 | `var' == 1) 
		if ("`X'" == "voted2005g" | "`X'" == "voted2006g" ) {
			randcmdc ((`var') areg `X' paper $covariates $priorvoting if completematch=="yes", absorb(cells)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}
		else {
			randcmdc ((`var') areg `X' paper $covariates doperator*, absorb(cells)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}
		}
	}

*APPENDIX TABLE 2
foreach X in iraqdead libby miers mostimp_scandals iraq_post iraq leak alito repfavorable demunfavorable bushapproval conservative {
	foreach var in post times {
		global i = $i + 1
		capture drop Strata
		gen Strata = (paper == 0 | `var' == 1) 
		randcmdc ((`var') areg `X' post times $covariates doperator*, absorb(cells)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	foreach var in paper {
		global i = $i + 1
		capture drop Strata
		gen Strata = (paper == 0 | `var' == 1) 
		randcmdc ((`var') areg `X' paper $covariates doperator*, absorb(cells)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
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
save results\FisherCondGKB, replace





