
*randomizing at treatment level

****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ll ul cluster(string)]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	global k = wordcount("`testvars'")
	if ("`cmd'" ~= "mlogit") {
		`cmd' `anything' `if' `in', `ll' `ul' cluster(`cluster')
		}
	else {
		`cmd' `anything' `if' `in', cluster(`cluster')
		global k = $k*2
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), $k-r(df), e(df_r), $k
		local i = 0
		if ("`cmd'" ~= "mlogit") {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		else {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = _b[3:`var'], _se[3:`var']
				local i = `i' + 1
				matrix B[$j+`i',1] = _b[7:`var'], _se[7:`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, ll ul cluster(string)]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	global k = wordcount("`testvars'")
	if ("`cmd'" ~= "mlogit") {
		capture `cmd' `anything' `if' `in', `ll' `ul' cluster(`cluster')
		}
	else {
		capture `cmd' `anything' `if' `in', cluster(`cluster')
		global k = $k*2
		}
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), $k-r(df), e(df_r)
			local i = 0
			if ("`cmd'" ~= "mlogit") {
				foreach var in `testvars' {
					matrix BB[$j+`i',1] = _b[`var'], _se[`var']
					local i = `i' + 1
					}
				}
			else {
				foreach var in `testvars' {
					matrix BB[$j+`i',1] = _b[3:`var'], _se[3:`var']
					local i = `i' + 1
					matrix BB[$j+`i',1] = _b[7:`var'], _se[7:`var']
					local i = `i' + 1
					}
				}
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************
use DatAFGH, clear

generate AM = 1 if abs_s < 13
replace AM = 0 if abs_s >= 13
egen cluster = group(grex_session AM), label

matrix F = J(24,4,.)
matrix B = J(57,2,.)

global i = 1
global j = 1

*Table 1
mycmd (treat_hi) reg profit_main treat_hi if (treat_lo | treat_hi), cluster(cluster)
mycmd (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), cluster(cluster)
mycmd (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), cluster(cluster)
mycmd (treat_hi) reg time_total_work_min treat_hi if (treat_lo | treat_hi), cluster(cluster)
mycmd (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), cluster(cluster)
mycmd (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), cluster(cluster)
mycmd (treat_hi) tobit time_total_work_min treat_hi if (treat_lo | treat_hi), ul cluster(cluster)
mycmd (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), ul cluster(cluster)
mycmd (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), ul cluster(cluster)

*Table 2
mycmd (treat_hi) mlogit pm_3_7_else treat_hi if (treat_lo | treat_hi), cluster(cluster)
mycmd (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), cluster(cluster)
mycmd (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), cluster(cluster)

*Table 3
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)

*Table 4 
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r if (treat_lo | treat_nosal | treat_r), cluster(cluster)
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal |treat_r), cluster(cluster)
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal |treat_r), cluster(cluster)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), ll cluster(cluster)
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if ( treat_lo | treat_nosal | treat_r | treat_sal), ll cluster(cluster)
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), ll cluster(cluster)

bysort cluster: gen NN = _n
sort NN cluster
global N = 49
mata Y = st_data((1,$N),("treat_hi","treat_nosal","treat_r","treat_lo","treat_sal"))
generate Order = _n
generate double U = .

mata ResF = J($reps,24,.); ResD = J($reps,24,.); ResDF = J($reps,24,.); ResB = J($reps,57,.); ResSE = J($reps,57,.)
forvalues c = 1/$reps {
	matrix FF = J(24,3,.)
	matrix BB = J(57,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("treat_hi","treat_nosal","treat_r","treat_lo","treat_sal"),Y)
	sort cluster NN
	foreach j in treat_hi treat_nosal treat_r treat_lo treat_sal {
		quietly replace `j' = `j'[_n-1] if cluster == cluster[_n-1] 
		}

global i = 1
global j = 1

*Table 1
mycmd1 (treat_hi) reg profit_main treat_hi if (treat_lo | treat_hi), cluster(cluster)
mycmd1 (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), cluster(cluster)
mycmd1 (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), cluster(cluster)
mycmd1 (treat_hi) reg time_total_work_min treat_hi if (treat_lo | treat_hi), cluster(cluster)
mycmd1 (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), cluster(cluster)
mycmd1 (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), cluster(cluster)
mycmd1 (treat_hi) tobit time_total_work_min treat_hi if (treat_lo | treat_hi), ul cluster(cluster)
mycmd1 (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), ul cluster(cluster)
mycmd1 (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), ul cluster(cluster)

*Table 2
mycmd1 (treat_hi) mlogit pm_3_7_else treat_hi if (treat_lo | treat_hi), cluster(cluster)
mycmd1 (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), cluster(cluster)
mycmd1 (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), cluster(cluster)

*Table 3
mycmd1 (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)
mycmd1 (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)
mycmd1 (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)

*Table 4 
mycmd1 (treat_nosal treat_r) reg profit_main treat_nosal treat_r if (treat_lo | treat_nosal | treat_r), cluster(cluster)
mycmd1 (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal |treat_r), cluster(cluster)
mycmd1 (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal |treat_r), cluster(cluster)
mycmd1 (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)
mycmd1 (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)
mycmd1 (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), cluster(cluster)
mycmd1 (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), ll cluster(cluster)
mycmd1 (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if ( treat_lo | treat_nosal | treat_r | treat_sal), ll cluster(cluster)
mycmd1 (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), ll cluster(cluster)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..24] = FF[.,1]'; ResD[`c',1..24] = FF[.,2]'; ResDF[`c',1..24] = FF[.,3]'
mata ResB[`c',1..57] = BB[.,1]'; ResSE[`c',1..57] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/24 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/57 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
gen N = _n
sort N
svmat double F
svmat double B
save results\FisherAAFGH, replace







