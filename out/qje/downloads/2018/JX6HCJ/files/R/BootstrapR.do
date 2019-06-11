
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust fe]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust' `fe'
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
			capture `anything', cluster(`newcluster') `robust' `fe'
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

global cluster = "id"

use DatR, clear

global i = 1
global j = 1

*Table 3 
foreach Y in 1 0 {
	foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_children_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', fe cluster(id)
		}
	}
 
*Table 4 
foreach Y in 1 0 {
	foreach X in tot_flow_spouse_you_resp tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', fe cluster(id) 
		}
	}

use ip\BS1, clear
forvalues i = 2/26 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/26 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapR, replace

