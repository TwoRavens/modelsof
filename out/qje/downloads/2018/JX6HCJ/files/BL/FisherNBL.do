
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') 
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
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster') 
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

*Controls from the fall 2007 survey;
global f07_child_controls "f07_heads_child_cnt f07_girl_cnt f07_age_cnt"
global f07_hh_controls "f07_duration_village_cnt f07_farsi_cnt f07_tajik_cnt f07_farmer_cnt f07_age_head_cnt f07_yrs_ed_head_cnt f07_num_ppl_hh_cnt f07_jeribs_cnt f07_num_sheep_cnt f07_nearest_scl" 
global f07_hh_controls_nodist "f07_duration_village_cnt f07_farsi_cnt f07_tajik_cnt f07_farmer_cnt f07_age_head_cnt f07_yrs_ed_head_cnt f07_num_ppl_hh_cnt f07_jeribs_cnt f07_num_sheep_cnt" 
*Controls from the spring 2008 survey;
global s08_child_controls "s08_heads_child_cnt s08_girls_cnt s08_age_cnt"
global s08_hh_controls "s08_duration_village_cnt s08_farsi_cnt s08_tajik_cnt s08_farmer_cnt s08_age_head_cnt s08_yrs_ed_head_cnt s08_num_ppl_hh_cnt s08_jeribs_cnt s08_num_sheep_cnt s08_nearest_scl" 
global s08_hh_controls_nodist "s08_duration_village_cnt s08_farsi_cnt s08_tajik_cnt s08_farmer_cnt s08_age_head_cnt s08_yrs_ed_head_cnt s08_num_ppl_hh_cnt s08_jeribs_cnt s08_num_sheep_cnt" 

*My code: some controls always dropped, so remove them from the globals
global f07_child_controls2 "f07_heads_child_cnt f07_age_cnt"
global s08_child_controls2 "s08_heads_child_cnt s08_age_cnt"

use DatBL, clear

matrix F = J(16,4,.)
matrix B = J(20,2,.)

global i = 1
global j = 1

*Table 4
mycmd (treatment) reg f07_formal_school treatment chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment) reg f07_formal_school treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment) reg f07_both_norma_total treatment chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment) reg f07_both_norma_total treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 1, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment $s08_child_controls2 $s08_hh_controls chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 1, cluster(clustercode)
mycmd (treatment) reg f07_formal_school treatment chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment) reg f07_formal_school treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment) reg f07_both_norma_total treatment chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment) reg f07_both_norma_total treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 0, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment $s08_child_controls2 $s08_hh_controls chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 0, cluster(clustercode)

*Table 5 
mycmd (treatment f07_treat_age)reg f07_formal_school treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment f07_treat_age) reg f07_formal_school treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment f07_treat_age) reg f07_both_norma_total treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment f07_treat_age) reg f07_both_norma_total treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)

bysort clustercode: gen N = _n
sort N clustercode
global N = 11
mata Y = st_data((1,$N),"treatment")
generate Order = _n
generate double U = .

mata ResF = J($reps,16,.); ResD = J($reps,16,.); ResDF = J($reps,16,.); ResB = J($reps,20,.); ResSE = J($reps,20,.)
forvalues c = 1/$reps {
	matrix FF = J(16,3,.)
	matrix BB = J(20,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"treatment",Y)
	sort clustercode N
	quietly replace treatment = treatment[_n-1] if clustercode == clustercode[_n-1] & N > 1
	quietly replace f07_treat_age = f07_age_cnt * treatment

global i = 1
global j = 1

*Table 4
mycmd1 (treatment) reg f07_formal_school treatment chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd1 (treatment) reg f07_formal_school treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd1 (treatment) reg f07_both_norma_total treatment chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd1 (treatment) reg f07_both_norma_total treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd1 (treatment) reg s08_both_norma_total treatment chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 1, cluster(clustercode)
mycmd1 (treatment) reg s08_both_norma_total treatment $s08_child_controls2 $s08_hh_controls chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 1, cluster(clustercode)
mycmd1 (treatment) reg f07_formal_school treatment chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd1 (treatment) reg f07_formal_school treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd1 (treatment) reg f07_both_norma_total treatment chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd1 (treatment) reg f07_both_norma_total treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd1 (treatment) reg s08_both_norma_total treatment chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 0, cluster(clustercode)
mycmd1 (treatment) reg s08_both_norma_total treatment $s08_child_controls2 $s08_hh_controls chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 0, cluster(clustercode)

*Table 5 
mycmd1 (treatment f07_treat_age)reg f07_formal_school treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd1 (treatment f07_treat_age) reg f07_formal_school treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd1 (treatment f07_treat_age) reg f07_both_norma_total treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd1 (treatment f07_treat_age) reg f07_both_norma_total treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..16] = FF[.,1]'; ResD[`c',1..16] = FF[.,2]'; ResDF[`c',1..16] = FF[.,3]'
mata ResB[`c',1..20] = BB[.,1]'; ResSE[`c',1..20] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/16 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/20 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherBL, replace


*****************************************


