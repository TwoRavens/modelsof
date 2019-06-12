
***************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust logit]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust' `logit'
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
			if ("`cluster'" ~= "") {
				capture drop PAIR*
				capture tab pair, gen(PAIR)
				capture drop PAIR1
				capture `anything', cluster(`newcluster') `robust' `logit'
				}
			else {
				capture drop S*
				capture tab school_id, gen(S)
				capture drop S1
				capture `anything', `robust' iterate(25)
				}
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



************************************

global cluster = "school_id"

global i = 1
global j = 1

use DatAL1, clear

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

********************************

use DatAL2, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S* if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S* if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S* if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S* if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'bot_p == 1, robust
	}

*****************************

use DatAL3, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S* if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S* if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S* if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S* if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'bot_p == 1, robust
	}

*************

use DatAL4, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S* if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S* if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S* if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S* if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S* if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S* if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S* if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S* if b`g'bot_p == 1, robust
	}

************************

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

*******************

use DatAL6, clear

foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'top_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S* if b`g'top_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'bot_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S* if b`g'bot_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'top_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S* if b`g'top_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'bot_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S* if b`g'bot_pq == 1, robust
	}

*************************

use DatAL7, clear

foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		mycmd (treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S* if boy == `g' & b`g'zak_`outcome' == 1, robust
		}
	}
foreach g in 0 1 {
	foreach year in 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			mycmd (treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

************

use DatAL8, clear

foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	}

****************************

use ip\BS1, clear
forvalues i = 2/180 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/180 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapAL, replace

use results\BootstrapAL, clear
matrix list = (33,34,35,36,41,42,43,44)
forvalues i = 1/8 {
	local j = `i' + 180
	local k = list[1,`i']
	foreach var in ResFF ResF ResDF ResD ResB ResSE {
		gen double `var'`j' = `var'`k'
		}
	}
forvalues i = 1/8 {
	local j = `i' + 180
	local k = list[1,`i']
	foreach var in B1 B2 {
		replace `var' = `var'[`k'] if _n == `j'
		}
	}
aorder
save results\BootstrapAL, replace

		
	




