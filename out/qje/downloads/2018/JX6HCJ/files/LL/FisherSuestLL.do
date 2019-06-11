
*($ncluster/($ncluster-1)) adjustment to V is the one Stata uses - Stata counts total clusters in data set, not necessarily those used in estimation
*doesn't matter for bootstrap & fisher, also doesn't matter for conventional results, as p-values well beyond cutoff boundaries


*randomizing at their clustering level


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

use DatLL, clear

global cluster = "uniqueid"
global panelvar = "uniqueid"
global Ti = 6
global ncluster = 179
bysort $cluster $panelvar: gen n = _n
bysort $cluster: gen nn = _n
generate byte constant = 1

*Table 1
global i = 1
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 z_overconfidence {
	mycmd (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period, re mle
	}

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 1 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = test
matrix DC = dc

*Table 2
global i = 1
foreach X in "male z_extraversion z_agreeableness z_conscientiousness z_emotionalstability z_openness" "salary5 job_media job_doctor job_engineer job_management job_marketing job_teacher job_researcher job_whitecollar" {
	mycmd (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period  if falseanswers == 0, re mle
	}

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 2 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = F \ test
matrix DC = DC \ dc

*Table 3 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
global i = 1
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd (payescalate paydif) xtreg `X' payescalate paydif difference_belief risk_cert_equiv practice_score_max period if choice == 1, re mle
	}

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 3 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = F \ test
matrix DC = DC \ dc

*Table 4 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
global i = 1
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd (payescalate payover) xtreg `X' payescalate payover overconf_hat risk_cert_equiv practice_score_max period if choice == 1, re mle
	}

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 4 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = F \ test
matrix DC = DC \ dc

*Table 5 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
global i = 1
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 {
	mycmd (payescalate pay`X') xtreg mistake_convex payescalate pay`X' `X' risk_cert_equiv practice_score_max period if choice == 1, re mle
	}
mycmd (payescalate payz_overconf) xtreg mistake_convex payescalate payz_overconf z_overconf risk_cert_equiv practice_score_max period if choice == 1 & falseanswers == 0, re mle

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 5 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = F \ test
matrix DC = DC \ dc

*Table 6 
global i = 1
mycmd (choice_linear choice_convex escalate_linear escalate_convex) xtreg number_score choice_linear choice_convex escalate_linear escalate_convex payscheme practice_score_max period , re mle
	
mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 6 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = F \ test
matrix DC = DC \ dc

sort nn uniqueid
sum nn if nn == 1
global N = r(N)
mata Y = st_data((1,$N),("choice","escalate"))
generate Order = _n
generate double U = .

mata ResF = J($reps,30,.); ResDC = J($reps,6,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("choice","escalate"),Y)
	sort uniqueid nn
	foreach j in choice escalate {
		quietly replace `j' = `j'[_n-1] if uniqueid == uniqueid[_n-1] 
		}
	quietly replace payescalate = (escalate == 1 & period >= 7)
	quietly replace paydif = payescalate*difference_belief
	quietly replace payover = payescalate*overconf_hat
	foreach j in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 z_overconf {
		quietly replace pay`j' = payescalate*`j'
		}
	quietly replace choice_linear = (payscheme == 0)&(choice == 1)&(escalate == 0)
	quietly replace choice_convex = (payscheme == 1)&(choice == 1)&(escalate == 0)
	quietly replace escalate_linear = (payscheme == 0)&(choice == 1)&(escalate == 1)
	quietly replace escalate_convex = (payscheme == 1)&(choice == 1)&(escalate == 1)

*Table 1
global i = 1
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 z_overconfidence {
	mycmd (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period, re mle
	}

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 1 
mata ResF[`c',1..5] = test; ResDC[`c',1] = DC

*Table 2
global i = 1
foreach X in "male z_extraversion z_agreeableness z_conscientiousness z_emotionalstability z_openness" "salary5 job_media job_doctor job_engineer job_management job_marketing job_teacher job_researcher job_whitecollar" {
	mycmd (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period  if falseanswers == 0, re mle
	}

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 2 
mata ResF[`c',6..10] = test; ResDC[`c',2] = DC

*Table 3 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
global i = 1
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd (payescalate paydif) xtreg `X' payescalate paydif difference_belief risk_cert_equiv practice_score_max period if choice == 1, re mle
	}

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 3 
mata ResF[`c',11..15] = test; ResDC[`c',3] = DC

*Table 4 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
global i = 1
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd (payescalate payover) xtreg `X' payescalate payover overconf_hat risk_cert_equiv practice_score_max period if choice == 1, re mle
	}

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 4 
mata ResF[`c',16..20] = test; ResDC[`c',4] = DC

*Table 5 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
global i = 1
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 {
	mycmd (payescalate pay`X') xtreg mistake_convex payescalate pay`X' `X' risk_cert_equiv practice_score_max period if choice == 1, re mle
	}
mycmd (payescalate payz_overconf) xtreg mistake_convex payescalate payz_overconf z_overconf risk_cert_equiv practice_score_max period if choice == 1 & falseanswers == 0, re mle

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 5 
mata ResF[`c',21..25] = test; ResDC[`c',5] = DC

*Table 6 
global i = 1
mycmd (choice_linear choice_convex escalate_linear escalate_convex) xtreg number_score choice_linear choice_convex escalate_linear escalate_convex payscheme practice_score_max period , re mle
	
mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 6 
mata ResF[`c',26..30] = test; ResDC[`c',6] = DC

}

drop _all
set obs $reps
forvalues i = 1/30 {
	quietly generate double ResF`i' = .
	}
forvalues i = 1/6 {
	quietly generate double ResDC`i' = .
	}
mata st_store(.,.,(ResF, ResDC))
svmat double F
svmat double DC
gen N = _n
save results\FisherSuestLL, replace


*******************************

