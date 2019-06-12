
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust logit iterate(string)]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	if ("`logit'" ~= "") local cmd = "logit"
	if ("`logit'" == "" & "`cmd'" == "brl") local cmd = "reg"
	global k = wordcount("`testvars'")
	if ("`iterate'" ~= "") {
		capture `cmd' `anything' `if' `in', iterate(`iterate')
		}
	else {
		capture `cmd' `anything' `if' `in', 
		}
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust logit iterate(string)]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	if ("`logit'" ~= "") local cmd = "logit"
	if ("`logit'" == "" & "`cmd'" == "brl") local cmd = "reg"
	global k = wordcount("`testvars'")
	if ("`iterate'" ~= "") {
		capture `cmd' `anything' `if' `in', iterate(`iterate')
		}
	else {
		capture `cmd' `anything' `if' `in', 
		}
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end


****************************************
****************************************

global reps = 39

global b = 32

matrix B = J(180,1,.)

use DatAL1, clear

global j = 1
*Table 2
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g', cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g', logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, logit cluster(school_id)
	}

mycmd (treated) brl zakaibag treated semarab semrel, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel PAIR*, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel PAIR*, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR*, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR*, logit cluster(school_id)

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

mata ResB= J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve
drop if school_id == `c'

global j = 1
*Table 2
foreach g in 0 1 {
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g', cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g', logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, logit cluster(school_id)
	}

mycmd1 (treated) brl zakaibag treated semarab semrel, cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel, logit cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel PAIR*, cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel PAIR*, logit cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, logit cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR*, cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR*, logit cluster(school_id)

*Table 4
foreach g in 0 1 {
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls50 if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p100 if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p50 if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeAL1, replace

**************************
**************************

global b = 16

use DatAL2, clear

global j = 33
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S* if b`g'bot_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'bot_p == 1, robust iterate(50)
	}

mata ResB= J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve
drop if school_id == `c'

global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls100 year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls25 year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p100 year S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p25 year S* if b`g'bot_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'bot_p == 1, robust iterate(50)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 33/48 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeAL2, replace

**************************
**************************

global b = 16

use DatAL3, clear

global j = 49
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S* if b`g'bot_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'bot_p == 1, robust iterate(50)
	}

mata ResB= J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve
drop if school_id == `c'

global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls100 year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls25 year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p100 year S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p25 year S* if b`g'bot_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'bot_p == 1, robust iterate(50)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 49/64 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeAL3, replace

**************************
**************************

global b = 16

use DatAL4, clear

global j = 65
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S* if b`g'bot_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S* if b`g'bot_p == 1, robust iterate(50)
	}

mata ResB= J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve
drop if school_id == `c'

global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S* if b`g'bot_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S* if b`g'bot_p == 1, robust iterate(50)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 65/80 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeAL4, replace

**************************
**************************

global b = 16

use DatAL5, clear

global j = 81
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

mata ResB= J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve
drop if school_id == `c'

global j = 1
foreach g in 0 1 {
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 81/96 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeAL5, replace

**************************
**************************

global b = 16

use DatAL6, clear

global j = 97
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'top_lsq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S* if b`g'top_lsq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'bot_lsq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S* if b`g'bot_lsq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'top_pq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S* if b`g'top_pq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'bot_pq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S* if b`g'bot_pq == 1, robust iterate(50)
	}

mata ResB= J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve
drop if school_id == `c'

global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab semrel year S* if b`g'top_lsq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'ls S* if b`g'top_lsq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year S* if b`g'bot_lsq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'ls S* if b`g'bot_lsq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year S* if b`g'top_pq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'p S* if b`g'top_pq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year S* if b`g'bot_pq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'p S* if b`g'bot_pq == 1, robust iterate(50)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 97/112 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeAL6, replace

**************************
**************************

global b = 60

use DatAL7, clear

global j = 113
foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		mycmd (treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S* if boy == `g' & b`g'zak_`outcome' == 1, robust iterate(50)
		}
	}
foreach g in 0 1 {
	foreach year in 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			mycmd (treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

mata ResB= J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve
drop if school_id == `c'

global j = 1
foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		mycmd1 (treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S* if boy == `g' & b`g'zak_`outcome' == 1, robust iterate(50)
		}
	}
foreach g in 0 1 {
	foreach year in 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			mycmd1 (treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 113/172 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeAL7, replace

**************************
**************************

global b = 8

use DatAL8, clear

global j = 173
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	}

mata ResB= J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve
drop if school_id == `c'

global j = 1
foreach g in 0 1 {
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 173/180 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeAL8, replace

**************************
**************************

use ip\OJackknifeAL1, clear
forvalues i = 2/8 {
	merge 1:1 N using ip\OJackknifeAL`i', nogenerate
	}
svmat double B
set obs 188
foreach i in 33 34 35 36 {
	local j = `i' + 148
	quietly generate double ResB`j' = ResB`i'
	quietly replace B1 = B1[`i'] if _n == `j'
	}
foreach i in 41 42 43 44 {
	local j = `i' + 144
	quietly generate double ResB`j' = ResB`i'
	quietly replace B1 = B1[`i'] if _n == `j'
	}
aorder
save results\OJackknifeAL, replace


