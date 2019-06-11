capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) logit robust]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	if ("`cmd'" == "brl" & "`logit'" ~= "") {
		local cmd = "logit"
		}
	else if ("`cmd'" == "brl") {
		local cmd = "reg"
		}

	if ($i == 0) {
		global M = ""
		estimates clear
		}
	global i = $i + 1

	if ("`cmd'" == "logit") {
		capture `cmd' `anything' `if' `in', iterate(50)
		}
	else {
		capture `cmd' `anything' `if' `in'
		}
	if (_rc == 0) estimates store M$i
	global M = "$M" + " " + "M$i"

end

****************************************
****************************************

*Part I - Tables 2 & 4 - 2001 regressions (treatment year only, not specification checks)

use DatAL1, clear

*Table 2
global i = 0
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

quietly suest $M, cluster(school_id)
test treated
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

*Table 4
global i = 0
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

quietly suest $M, cluster(school_id)
test treated
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

global N = 40
mata Y = st_data((1,$N),"Y2")
generate double U = .
generate Order = _n

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U 
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}

*Table 2
global i = 0
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

capture suest $M, cluster(school_id)
if (_rc == 0) {
	capture test treated
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
		}
	}

*Table 4
global i = 0
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

capture suest $M, cluster(school_id)
if (_rc == 0) {
	capture test treated
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
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
sort N
save ip\FisherSuestAL1, replace


********************************

*Table 2

use DatAL2, clear
sort year student_id
foreach j in b0top_ls b0bot_ls b0top_p b0bot_p b1top_ls b1bot_ls b1top_p b1bot_p {
	gen S`j' = (`j' == 1)
	}
drop b0top_ls b0bot_ls b0top_p b0bot_p b1top_ls b1bot_ls b1top_p b1bot_p 
save a1, replace

use DatAL3, clear
replace year = 2 - year
sort year student_id
foreach j in b0top_ls b0bot_ls b0top_p b0bot_p b1top_ls b1bot_ls b1top_p b1bot_p {
	gen SS`j' = (`j' == 1)
	}
drop b0top_ls b0bot_ls b0top_p b0bot_p b1top_ls b1bot_ls b1top_p b1bot_p 
save a2, replace

use DatAL4, clear
generate Order = _n
gen Year1 = (year == 1)
replace Year1 = . if year == 2
gen Year2 = (year == 1) 
replace Year2 = . if year == 0

merge 1:1 year student_id using a1
tab year _m
drop _m
merge 1:1 year student_id using a2
tab year _m
drop _m

*Table 5
global i = 0
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'ls100 Year1 S2-S39 if Sb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'ls Year1 S2-S39 if Sb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'ls25 Year1 S2-S39 if Sb`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'ls Year1 S2-S39 if Sb`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'p100 Year1 S2-S39 if Sb`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'p Year1 S2-S39 if Sb`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'p25 Year1 S2-S39 if Sb`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'p Year1 S2-S39 if Sb`g'bot_p == 1, robust
	}

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'ls100 Year2 S2-S39 if SSb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'ls Year2 S2-S39 if SSb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'ls25 Year2 S2-S39 if SSb`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'ls Year2 S2-S39 if SSb`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'p100 Year2 S2-S39 if SSb`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'p Year2 S2-S39 if SSb`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'p25 Year2 S2-S39 if SSb`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'p Year2 S2-S39 if SSb`g'bot_p == 1, robust
	}

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

quietly suest $M, robust
test treated
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

global N = 40
sort Order
mata Y = st_data((1,$N),"Y2")
generate double U = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}
	quietly replace treated = treated*year1

*Table 5
global i = 0
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'ls100 Year1 S2-S39 if Sb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'ls Year1 S2-S39 if Sb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'ls25 Year1 S2-S39 if Sb`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'ls Year1 S2-S39 if Sb`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'p100 Year1 S2-S39 if Sb`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'p Year1 S2-S39 if Sb`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'p25 Year1 S2-S39 if Sb`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semrel1 b`g'p Year1 S2-S39 if Sb`g'bot_p == 1, robust
	}

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'ls100 Year2 S2-S39 if SSb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'ls Year2 S2-S39 if SSb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'ls25 Year2 S2-S39 if SSb`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'ls Year2 S2-S39 if SSb`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'p100 Year2 S2-S39 if SSb`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'p Year2 S2-S39 if SSb`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'p25 Year2 S2-S39 if SSb`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab2 semrel2 b`g'p Year2 S2-S39 if SSb`g'bot_p == 1, robust
	}

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

capture suest $M, robust
if (_rc == 0) {
	capture test treated
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}
}

drop _all
set obs $reps
forvalues i = 11/15 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestAL2, replace


************************


*Table 6

use DatAL5, clear
sort year student_id
foreach j in b0top_lsq b0bot_lsq b0top_pq b0bot_pq b1top_lsq b1bot_lsq b1top_pq b1bot_pq {
	gen S`j' = `j' == 1
	}
drop b0top_lsq b0bot_lsq b0top_pq b0bot_pq b1top_lsq b1bot_lsq b1top_pq b1bot_pq 
save a1, replace

use DatAL6, clear
generate Order = _n
merge 1:1 year student_id using a1
tab year _m

global i = 0
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & Sb`g'top_lsq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & Sb`g'top_lsq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & Sb`g'bot_lsq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & Sb`g'bot_lsq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & Sb`g'top_pq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & Sb`g'top_pq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & Sb`g'bot_pq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & Sb`g'bot_pq == 1 & year == 1, logit cluster(school_id)
	}
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

quietly suest $M, cluster(school_id)
test treated
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

sort Order
global N = 40
mata Y = st_data((1,$N),"Y2")
generate double U = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}
	quietly replace treated = treated*year

global i = 0
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & Sb`g'top_lsq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & Sb`g'top_lsq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & Sb`g'bot_lsq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & Sb`g'bot_lsq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & Sb`g'top_pq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & Sb`g'top_pq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & Sb`g'bot_pq == 1 & year == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & Sb`g'bot_pq == 1 & year == 1, logit cluster(school_id)
	}
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

capture suest $M, cluster(school_id)
if (_rc == 0) {
	capture test treated
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
		}
	}
}

drop _all
set obs $reps
forvalues i = 16/20 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestAL5, replace


*************************

*Table 7 - 2001 and 2000/2001 regressions only (not 2000 regressions, following procedure for all such regressions in this paper)

use DatAL7, clear

global i = 0
foreach g in 0 {
	foreach outcome in att18 att22 att24 awr20 awr24 achv_math achv_eng achv_hib bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		mycmd (treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S2-S39 if boy == `g' & b`g'zak_`outcome' == 1, robust
		}
	}

foreach g in 1 {
	foreach outcome in att20 att22 att24 awr18 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att22 bag_cond_att24 {
		mycmd (treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S2-S39 if boy == `g' & b`g'zak_`outcome' == 1, robust
		}
	}


foreach g in 0 {
	foreach year in 1 {
		foreach outcome in att18 att24 awr18 achv_math achv_eng achv_hib bag_cond_att22 bag_cond_att24 {
			mycmd (treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

foreach g in 1 {
	foreach year in 1 {
		foreach outcome in att20 att22 att24 awr24 achv_math achv_eng bag_cond_att18 bag_cond_att24 {
			mycmd (treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

quietly suest $M, cluster(school_id)
test treated treated01
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

global N = 40 
mata Y = st_data((1,$N),"Y2")
generate double U = .
generate Order = _n

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}
	quietly replace treated01 = treated*year01

global i = 0
foreach outcome in att18 att22 att24 awr20 awr24 achv_math achv_eng achv_hib bag_cond_att20 bag_cond_att22 bag_cond_att24 {
	mycmd (treated01) logit `outcome' treated01 semarab01 semrel01 b0ls100 year01 S2-S39 if boy == 0 & b0zak_`outcome' == 1, robust
	}

foreach outcome in att20 att22 att24 awr18 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att22 bag_cond_att24 {
	mycmd (treated01) logit `outcome' treated01 semarab01 semrel01 b1ls100 year01 S2-S39 if boy == 1 & b1zak_`outcome' == 1, robust
	}

foreach outcome in att18 att24 awr18 achv_math achv_eng achv_hib bag_cond_att22 bag_cond_att24 {
	mycmd (treated) brl `outcome' treated semarab semrel b0ls100 if year == 1 & boy == 0 & b0zak_`outcome' == 1, logit cluster(school_id)
	}

foreach outcome in att20 att22 att24 awr24 achv_math achv_eng bag_cond_att18 bag_cond_att24 {
	mycmd (treated) brl `outcome' treated semarab semrel b1ls100 if year == 1 & boy == 1 & b1zak_`outcome' == 1, logit cluster(school_id)
	}

capture suest $M, cluster(school_id)
if (_rc == 0) {
	capture test treated treated01
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 7)
		}
	}
}

drop _all
set obs $reps
forvalues i = 21/25 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestAL7, replace

************

*Part 8:  Table A5 

use DatAL2, clear
sort year student_id
foreach j in b0top_ls b0bot_ls b0top_p b0bot_p b1top_ls b1bot_ls b1top_p b1bot_p {
	gen S`j' = `j' == 1
	}
drop b0top_ls b0bot_ls b0top_p b0bot_p b1top_ls b1bot_ls b1top_p b1bot_p 
save a1, replace

use DatAL8, clear
generate Order = _n
gen Sample = 1
rename b0top_ls bb0top_ls 
rename b1top_ls bb1top_ls
merge 1:1 year student_id using a1
tab _m year

global i = 0
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & bb`g'top_ls == 1 & Sample == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & bb`g'top_ls == 0 & Sample == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & bb`g'top_ls == 1 & Sample == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & bb`g'top_ls == 0 & Sample == 1, logit cluster(school_id)
	}

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if Sb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if Sb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if Sb`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if Sb`g'bot_ls == 1, robust
	}

quietly suest $M, cluster(school_id)
test treated
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 105)

sort Order
global N = 40
mata Y = st_data((1,$N),"Y2")
generate double U = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}
	quietly replace treated = treated*year

global i = 0
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & bb`g'top_ls == 1 & Sample == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & bb`g'top_ls == 0 & Sample == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & bb`g'top_ls == 1 & Sample == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & bb`g'top_ls == 0 & Sample == 1, logit cluster(school_id)
	}

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if Sb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if Sb`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if Sb`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if Sb`g'bot_ls == 1, robust
	}

capture suest $M, cluster(school_id)
if (_rc == 0) {
	capture test treated
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 105)
		}
	}
}

drop _all
set obs $reps
forvalues i = 26/30 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestAL8, replace


******************************************

use ip\FisherSuestAL1, clear
merge 1:1 N using ip\FisherSuestAL2, nogenerate
merge 1:1 N using ip\FisherSuestAL5, nogenerate
merge 1:1 N using ip\FisherSuestAL7, nogenerate
merge 1:1 N using ip\FisherSuestAL8, nogenerate
drop F*
svmat double F
aorder
save results\FisherSuestAL, replace








