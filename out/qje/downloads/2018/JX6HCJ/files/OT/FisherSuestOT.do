
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* xxx* Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
	quietly generate Ssample$i = e(sample)
	quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
	quietly predict double yyy$i if Ssample$i, resid
	local newtestvars = ""
	foreach var in `testvars' {
		quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
		quietly predict double xxx`var'$i if Ssample$i, resid
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	quietly reg yyy$i `newtestvars', noconstant
	estimates store M$i
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************


use DatOT, clear

*Table 2
global i = 0
mycmd (treatment) areg attendance treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd (treat_period) areg attendance treat_period period RESPID2-RESPID198 if after==1, cluster(respid) absorb(date_group)
mycmd (treatment) areg present_diary treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd (treat_period) areg present_diary treat_period period RESPID2-RESPID154 RESPID156-RESPID198 if after==1  , cluster(respid) absorb(date_group)

quietly suest $M, cluster(respid)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)
 
sort respid school_id
replace school_id = school_id[_n-1] if respid == respid[_n-1] & school_id == .
bysort school_id respid: gen N = _n
sort N school_id respid
global N = 198
generate Order = _n
generate U = .
mata Y = st_data((1,$N),"treatment")

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort school_id U in 1/$N
	mata st_store((1,$N),"treatment",Y)
	sort school_id respid N
	quietly replace treatment = treatment[_n-1] if respid == respid[_n-1] & school_id == school_id[_n-1] & N > 1
	quietly replace treat_period = treatment*period

*Table 2
global i = 0
mycmd (treatment) areg attendance treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd (treat_period) areg attendance treat_period period RESPID2-RESPID198 if after==1, cluster(respid) absorb(date_group)
mycmd (treatment) areg present_diary treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd (treat_period) areg present_diary treat_period period RESPID2-RESPID154 RESPID156-RESPID198 if after==1  , cluster(respid) absorb(date_group)

capture suest $M, cluster(respid)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/5 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save results\FisherSuestOT, replace



