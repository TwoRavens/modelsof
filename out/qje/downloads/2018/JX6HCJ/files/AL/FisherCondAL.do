
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust logit]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`cluster'" ~= "") {
		`anything' `if' `in', cluster(`cluster') `logit'
		}
	else {
		`anything' `if' `in', `robust'
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$ii,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$jj+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global ii = $ij + 1
global jj = $jj + $k
end


****************************************
****************************************

*Part I - Tables 2 & 4 - 2001 regressions (treatment year only, not specification checks)

use DatAL1, clear

matrix F = J(180,4,.)
matrix B = J(180,2,0)

global ii = 1
global jj = 1
*Table 2
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g', cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g', logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, logit cluster(school_id)
	}

mycmd (treated) brl zakaibag treated semarab semrel, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel PAIR2-PAIR19, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel PAIR2-PAIR19, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, logit cluster(school_id)

*Table 4
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls50 if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p100 if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p50 if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	}

gen Strata = .
forvalues i = 1/40 {
	local j = Y1[`i']
	quietly replace Strata = `j' if school_id == Y3[`i']
	}

global i = 0

*Table 2
foreach g in 0 1 {
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel if boy == `g', cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel if boy == `g', logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	}

global i = $i + 1
	randcmdc ((treated) brl zakaibag treated semarab semrel, cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
global i = $i + 1
	randcmdc ((treated) brl zakaibag treated semarab semrel, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
global i = $i + 1
	randcmdc ((treated) brl zakaibag treated semarab semrel PAIR2-PAIR19, cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
global i = $i + 1
	randcmdc ((treated) brl zakaibag treated semarab semrel PAIR2-PAIR19, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
global i = $i + 1
	randcmdc ((treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
global i = $i + 1
	randcmdc ((treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
global i = $i + 1
	randcmdc ((treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
global i = $i + 1
	randcmdc ((treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)

*Table 4
foreach g in 0 1 {
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'ls50 if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'p100 if boy == `g' & b`g'top_p == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'p50 if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_p == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	}

********************************

*Part II:  Table 5 - First part 

use DatAL2, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
	}

gen Strata = .
forvalues i = 1/40 {
	local j = Y1[`i']
	quietly replace Strata = `j' if school_id == Y3[`i']
	}
gen T = .
forvalues i = 1/40 {
	local j = Y2[`i']
	quietly replace T = `j' if school_id == Y3[`i']
	}

foreach g in 0 1 {
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	}


*****************************

*Part III: Table 5, second part

use DatAL3, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
	}

gen Strata = .
forvalues i = 1/40 {
	local j = Y1[`i']
	quietly replace Strata = `j' if school_id == Y3[`i']
	}

gen T = .
forvalues i = 1/40 {
	local j = Y2[`i']
	quietly replace T = `j' if school_id == Y3[`i']
	}

foreach g in 0 1 {
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	}

*************

*Part IV: Table 5, third part

use DatAL4, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S2-S39 if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'bot_p == 1, robust
	}

gen Strata = .
forvalues i = 1/40 {
	local j = Y1[`i']
	quietly replace Strata = `j' if school_id == Y3[`i']
	}

gen T = .
forvalues i = 1/40 {
	local j = Y2[`i']
	quietly replace T = `j' if school_id == Y3[`i']
	}

foreach g in 0 1 {
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S2-S39 if b`g'top_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year1*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'top_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year1*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S2-S39 if b`g'bot_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year1*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'bot_ls == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year1*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S2-S39 if b`g'top_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year1*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'top_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year1*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S2-S39 if b`g'bot_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year1*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'bot_p == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year1*T)
	}


************************

*Part V:  Table 6 , top panel 2001

use DatAL5, clear

foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	}

gen Strata = .
forvalues i = 1/40 {
	local j = Y1[`i']
	quietly replace Strata = `j' if school_id == Y3[`i']
	}

foreach g in 0 1 {
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) 
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) 
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) 
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) 
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) 
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) 
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) 
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) 
	}


*******************

*Part VI:  Table 6, bottom panel

use DatAL6, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'top_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'top_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'bot_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'top_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'top_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'bot_pq == 1, robust
	}

gen Strata = .
forvalues i = 1/40 {
	local j = Y1[`i']
	quietly replace Strata = `j' if school_id == Y3[`i']
	}

gen T = .
forvalues i = 1/40 {
	local j = Y2[`i']
	quietly replace T = `j' if school_id == Y3[`i']
	}

foreach g in 0 1 {
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'top_lsq == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'top_lsq == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_lsq == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'bot_lsq == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'top_pq == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'top_pq == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_pq == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	global i = $i + 1
		randcmdc ((treated) logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'bot_pq == 1, robust), treatvars(T) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated = year*T)
	}

*************************

*Part 7 - Table 7 - 2001 and 2000/2001 regressions only (not 2000 regressions, following procedure for all such regressions in this paper)

use DatAL7, clear

foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		mycmd (treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S2-S39 if boy == `g' & b`g'zak_`outcome' == 1, robust
		}
	}
foreach g in 0 1 {
	foreach year in 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			mycmd (treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

gen Strata = .
forvalues i = 1/40 {
	local j = Y1[`i']
	quietly replace Strata = `j' if school_id == Y3[`i']
	}

foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		global i = $i + 1
			randcmdc ((treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S2-S39 if boy == `g' & b`g'zak_`outcome' == 1, robust), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) calc1(replace treated01 = year01*treated)
		}
	}
foreach g in 0 1 {
	foreach year in 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			global i = $i + 1
				randcmdc ((treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id) 
			}
		}
	}

************

*Part 8:  Table A5 - Regressions that are new (not reproducing Table 5) 

use DatAL8, clear

foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	}

gen Strata = .
forvalues i = 1/40 {
	local j = Y1[`i']
	quietly replace Strata = `j' if school_id == Y3[`i']
	}

foreach g in 0 1 {
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	global i = $i + 1
		randcmdc ((treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)), treatvars(treated) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(school_id)
	}


matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondAL, replace

use results\FisherCondAL, clear
matrix list = (33,34,35,36,41,42,43,44)
forvalues i = 1/8 {
	local j = `i' + 180
	local k = list[1,`i']
	foreach var in ResF ResB ResSE {
		gen double `var'`j' = `var'`k'
		}
	}
forvalues i = 1/8 {
	local j = `i' + 180
	local k = list[1,`i']
	foreach var in B1 B2 T1 T2 F1 F2 F3 F4 {
		replace `var' = `var'[`k'] if _n == `j'
		}
	}
aorder
save results\FisherCondAL, replace

		
