
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) logit]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xxx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	if ("`cmd'" == "brl" & "`logit'" ~= "") {
		local cmd = "logit"
		}
	else if ("`cmd'" == "brl") {
		local cmd = "reg"
		} 
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xxx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xxx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************

matrix B = J(188,2,0)
global j = 1

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
test $test
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
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)


********************************

*Part II:  Table 5 - First part 

use DatAL2, clear
sort year student_id
foreach j in b0top_ls b0bot_ls b0top_p b0bot_p b1top_ls b1bot_ls b1top_p b1bot_p {
	gen S`j' = `j' == 1
	}
drop b0top_ls b0bot_ls b0top_p b0bot_p b1top_ls b1bot_ls b1top_p b1bot_p 
save a1, replace

use DatAL3, clear
replace year = 2 - year
sort year student_id
foreach j in b0top_ls b0bot_ls b0top_p b0bot_p b1top_ls b1bot_ls b1top_p b1bot_p {
	gen SS`j' = `j' == 1
	}
drop b0top_ls b0bot_ls b0top_p b0bot_p b1top_ls b1bot_ls b1top_p b1bot_p 
save a2, replace

use DatAL4, clear

gen Year1 = (year == 1)
replace Year1 = . if year == 2
gen Year2 = (year == 1) 
replace Year2 = . if year == 0

sort year student_id
merge year student_id using a1
tab year _m
drop _m
sort year student_id
merge year student_id using a2
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
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)


************************

*Part V:  Table 6 , top panel 2001

use DatAL5, clear
sort year student_id
foreach j in b0top_lsq b0bot_lsq b0top_pq b0bot_pq b1top_lsq b1bot_lsq b1top_pq b1bot_pq {
	gen S`j' = `j' == 1
	}
drop b0top_lsq b0bot_lsq b0top_pq b0bot_pq b1top_lsq b1bot_lsq b1top_pq b1bot_pq 
save a1, replace

use DatAL6, clear
sort year student_id
merge year student_id using a1
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
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

*************************

*Part 7 - Table 7 - 2001 and 2000/2001 regressions only (not 2000 regressions, following procedure for all such regressions in this paper)

use DatAL7, clear

global i = 0

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

quietly suest $M, cluster(school_id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

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
gen Sample = 1
rename b0top_ls bb0top_ls 
rename b1top_ls bb1top_ls
sort year student_id
merge year student_id using a1
tab _m

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
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 105)

**************************************

drop _all
svmat double F
svmat double B
save results/SuestAL, replace

capture erase a1.dta
capture erase a2.dta





