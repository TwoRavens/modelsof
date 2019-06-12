
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust absorb(string)]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', `robust' absorb(`absorb')
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse' 
			capture `anything', `robust' absorb(`absorb')
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

global cluster = ""

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

use ip\BS1, clear
forvalues i = 2/50 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/50 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapGKB, replace

