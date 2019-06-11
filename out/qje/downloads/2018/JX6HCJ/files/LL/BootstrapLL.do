
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust'
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse', cluster($cluster) idcluster(`newcluster')
			quietly xtset `newcluster'
			capture `anything', cluster(`newcluster') `robust'
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


*************************

global cluster = "uniqueid"

global i = 1
global j = 1

use DatLL, clear

*Table 1
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 z_overconfidence {
	mycmd (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period if feedback == 0 & period > 3, cluster(uniqueid)
	}

*Table 2
foreach X in "male z_extraversion z_agreeableness z_conscientiousness z_emotionalstability z_openness" "salary5 job_media job_doctor job_engineer job_management job_marketing job_teacher job_researcher job_whitecollar" {
	mycmd (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period if feedback == 0 & period > 3 & falseanswers == 0, cluster(uniqueid)
	}

*Table 3 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd (payescalate paydif) xtreg `X' payescalate paydif difference_belief risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(uniqueid)
	}

*Table 4 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd (payescalate payover) xtreg `X' payescalate payover overconf_hat risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(uniqueid)
	}

*Table 5 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 {
	mycmd (payescalate pay`X') xtreg mistake_convex payescalate pay`X' `X' risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(uniqueid)
	}

mycmd (payescalate payz_overconf) xtreg mistake_convex payescalate payz_overconf z_overconf risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1 & falseanswers == 0, cluster(uniqueid)

*Table 6 - Randomization in this case will take as given that linear versus convex matter, but testing whether treatment regimes mattered - see discussion in paper
mycmd (choice_linear choice_convex escalate_linear escalate_convex) xtreg number_score choice_linear choice_convex escalate_linear escalate_convex payscheme practice_score_max period if feedback == 0 & period > 3, cluster(uniqueid)
	

use ip\BS1, clear
forvalues i = 2/23 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/23 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapLL, replace

