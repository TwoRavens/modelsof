

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		matrix B = J(1,100,.)
		estimates clear
		global j = 0
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' [`weight' `exp'] if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' [`weight' `exp'] if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture reg yyy$i `newtestvars' [`weight' `exp'], noconstant
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	else {
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' 
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture `cmd' `dep' `newtestvars' `anything' `if' `in', 
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

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

*Dropping Stata drops

*Table 4
global i = 0
mycmd (treatment) reg f07_formal_school treatment chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
*mycmd (treatment) reg f07_formal_school treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment) reg f07_both_norma_total treatment chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment) reg f07_both_norma_total treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 1, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment $s08_child_controls2 $s08_hh_controls chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 1, cluster(clustercode)
mycmd (treatment) reg f07_formal_school treatment chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment) reg f07_formal_school treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
*mycmd (treatment) reg f07_both_norma_total treatment chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment) reg f07_both_norma_total treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 0, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment $s08_child_controls2 $s08_hh_controls chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 0, cluster(clustercode)

quietly suest $M, cluster(clustercode)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 4)
matrix B4 = B[1,1..$j]

*Table 5 
global i = 0
mycmd (treatment f07_treat_age)reg f07_formal_school treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment f07_treat_age) reg f07_formal_school treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment f07_treat_age) reg f07_both_norma_total treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment f07_treat_age) reg f07_both_norma_total treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)

quietly suest $M, cluster(clustercode)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)
matrix B5 = B[1,1..$j]

gen Order = _n
sort clustercode Order
gen N = 1
gen Dif = (clustercode ~= clustercode[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop clustercode
	rename obs clustercode


*Table 4
global i = 0
mycmd (treatment) reg f07_formal_school treatment chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment) reg f07_both_norma_total treatment chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment) reg f07_both_norma_total treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 1, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment $s08_child_controls2 $s08_hh_controls chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 1, cluster(clustercode)
mycmd (treatment) reg f07_formal_school treatment chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment) reg f07_formal_school treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment) reg f07_both_norma_total treatment $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 0, cluster(clustercode)
mycmd (treatment) reg s08_both_norma_total treatment $s08_child_controls2 $s08_hh_controls chagcharan if nonoutlier == 1 & s08_test_observed == 1 & s08_girls_cnt == 0, cluster(clustercode)

capture suest $M, cluster(clustercode)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
		}
	}

*Table 5 
global i = 0
mycmd (treatment f07_treat_age) reg f07_formal_school treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment f07_treat_age) reg f07_formal_school treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)
mycmd (treatment f07_treat_age) reg f07_both_norma_total treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 1, cluster(clustercode)
mycmd (treatment f07_treat_age) reg f07_both_norma_total treatment f07_treat_age $f07_child_controls2 $f07_hh_controls chagcharan if nonoutlier == 1 & f07_test_observed == 1 & f07_girl_cnt == 0, cluster(clustercode)

capture suest $M, cluster(clustercode)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/10 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\OBootstrapSuestBL, replace

erase aa.dta
erase aaa.dta
