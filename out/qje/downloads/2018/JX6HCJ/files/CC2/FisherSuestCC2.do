
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, re mle]
	tempvar touse xb e S1 S2 S3 S4 sum ssum
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab anything: `anything'
	global k = wordcount("`testvars'")
	quietly `cmd' `dep' `anything' `if' `in', `re' `mle'
	gen `touse' = e(sample)
	matrix b = e(b)
	matrix v = e(V)
	global kk = colsof(b)
	global a = 1/(b[1,$kk]^2)
	global b = (b[1,$kk-1]^2)/($Ti*b[1,$kk-1]^2+b[1,$kk]^2)
	global c = 1/($Ti*b[1,$kk-1]^2+b[1,$kk]^2)
	quietly predict double `xb', xb
	quietly gen double `e' = `dep' - `xb'
	matrix grad = J($ncluster,$kk,.)
	local anything = "`anything'" + " " + "constant"
	local i = 1
	quietly egen double `S1' = sum(`e'), by($panelvar)
	quietly egen double `S4' = sum(`e'*`e'), by($panelvar)
	foreach var in `anything' {
		quietly egen double `S2' = sum(`e'*`var'), by($panelvar)
		quietly egen double `S3' = sum(`var'), by($panelvar)
		quietly gen double `sum' = $a*(`S2' -$b*`S1'*`S3') if n == 1 & `touse' == 1
		quietly replace `sum' = 0 if `touse' == 0 & n == 1
		quietly egen double `ssum' = sum(`sum'), by($cluster)
		mkmat `ssum' if nn == 1, matrix(a)
		matrix grad[1,`i'] = a 
		local i = `i' + 1
		capture drop `S2' `S3' `sum' `ssum'
		}
	quietly gen double `sum' = ($b/b[1,$kk-1])*(`S1'*`S1'*$b/(b[1,$kk-1]^2) - $Ti) if n == 1 & `touse' == 1
	quietly replace `sum' = 0 if `touse' == 0 & n == 1
	quietly egen double `ssum' = sum(`sum'), by($cluster)
	mkmat `ssum' if nn == 1, matrix(a)
	matrix grad[1,`i'] = a 
	local i = `i' + 1
	capture drop `sum' `ssum'

	quietly gen double `sum' = -($Ti-1)/b[1,$kk] - $c*b[1,$kk] - $b*$c*`S1'*`S1'/b[1,$kk]+(`S4'-$b*`S1'*`S1')/(b[1,$kk]^3) if n == 1 & `touse' == 1
	quietly replace `sum' = 0 if `touse' == 0 & n == 1
	quietly egen double `ssum' = sum(`sum'), by($cluster)
	mkmat `ssum' if nn == 1, matrix(a)
	matrix grad[1,`i'] = a 
	local i = `i' + 1
	capture drop `sum' `ssum'

	mata b = st_matrix("b"); v = st_matrix("v"); grad = st_matrix("grad"); select = J(1,$kk,0); select[1,1..$k] = J(1,$k,1)
	if ($i == 1) {
		mata B = b; G = v*grad'; Select = select; dc = J(1,$ncluster,1)*grad; DC = dc*dc'
		}
	else {
		mata B = B, b; G = G \ (v*grad'); Select = Select, select; dc = J(1,$ncluster,1)*grad; DC = DC + dc*dc'
		}
global i = $i + 1
end

****************************************
****************************************

use DatCC2, clear

global cluster = "session"
global panelvar = "subject"
global Ti = 50
global ncluster = 18
bysort $cluster $panelvar: gen n = _n
bysort $cluster: gen nn = _n
generate byte constant = 1

*Table 2 
global i = 1
mycmd (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh, re mle
mycmd (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh age18 age19 age20 age21 age22 gender raceAsian raceBlack raceHispanic raceMulti raceOther raisedAsia married employedFull employedPart onesib twosib moresib expensesSharedSpouse-expensesOther voted-volunteer, re mle

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 2 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = test
matrix DC = dc

sort nn session
global N = 18
mata Y = st_data((1,$N),("ingroup","outgroup","inenh","outenh"))
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.); ResDC = J($reps,1,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("ingroup","outgroup","inenh","outenh"),Y)
	sort session nn
	foreach j in ingroup outgroup inenh outenh {
		quietly replace `j' = `j'[_n-1] if session == session[_n-1]
		}

*Table 2 
global i = 1
mycmd (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh, re mle
mycmd (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh age18 age19 age20 age21 age22 gender raceAsian raceBlack raceHispanic raceMulti raceOther raisedAsia married employedFull employedPart onesib twosib moresib expensesSharedSpouse-expensesOther voted-volunteer, re mle

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 2 
mata ResF[`c',1..5] = test; ResDC[`c',1] = DC

}


drop _all
set obs $reps
forvalues i = 1/5 {
	quietly generate double ResF`i' = .
	}
quietly generate double ResDC1 = .
mata st_store(.,.,(ResF, ResDC))
svmat double F
svmat double DC
gen N = _n
save results\FisherSuestCC2, replace





