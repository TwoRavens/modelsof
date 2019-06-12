
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', absorb(`absorb')
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
generate double U = .
mata Y = st_data(.,("treatment","post","times","paper"))

mata ResF = J($reps,50,.); ResD = J($reps,50,.); ResDF = J($reps,50,.); ResB = J($reps,75,.); ResSE = J($reps,75,.)
forvalues c = 1/$reps {
	matrix FF = J(50,3,.)
	matrix BB = J(75,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort cells U
	mata st_store(.,("treatment","post","times","paper"),Y)

global i = 1
global j = 1

*TABLE 2
foreach X in getapaper getpost gettimes readfrqr readsome {
	mycmd1 (post times) areg `X' post times $covariates doperator*, absorb(cells)
	mycmd1 (paper) areg `X' paper $covariates doperator*, absorb(cells)
	}

*TABLE 3
foreach X in factindex consindexpol consindexgen {
	mycmd1 (post times) areg `X' post times $covariates doperator*, absorb(cells)
	mycmd1 (paper) areg `X' paper $covariates doperator*, absorb(cells)
	}
	
*TABLE 4
foreach X in voted voted2005g voted2006g voteddem voteddem_all {
	if ("`X'" == "voted2005g" | "`X'" == "voted2006g" ) {
		mycmd1 (post times) areg `X' post times $covariates $priorvoting if completematch=="yes", absorb(cells)
		}
	else {
		mycmd1 (post times) areg `X' post times $covariates doperator*, absorb(cells)
		}
	if ("`X'" == "voted2005g" | "`X'" == "voted2006g" ) {
		mycmd1 (paper) areg `X' paper $covariates $priorvoting if completematch=="yes", absorb(cells)
		}
	else {
		mycmd1 (paper) areg `X' paper $covariates doperator*, absorb(cells)
		}
	}

*APPENDIX TABLE 2
foreach X in iraqdead libby miers mostimp_scandals iraq_post iraq leak alito repfavorable demunfavorable bushapproval conservative {
	mycmd1 (post times) areg `X' post times $covariates doperator*, absorb(cells)
	mycmd1 (paper) areg `X' paper $covariates doperator*, absorb(cells) 
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..50] = FF[.,1]'; ResD[`c',1..50] = FF[.,2]'; ResDF[`c',1..50] = FF[.,3]'
mata ResB[`c',1..75] = BB[.,1]'; ResSE[`c',1..75] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/50 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/75 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherGKB, replace


