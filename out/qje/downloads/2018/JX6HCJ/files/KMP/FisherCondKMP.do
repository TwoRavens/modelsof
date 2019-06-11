
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `robust'
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

use DatKMP, clear

matrix F = J(4,4,.)
matrix B = J(30,2,.)

global i = 1
global j = 1

*Table 2 
mycmd (money bottle pricetag choice origami) reg characters money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money timemoney bottle timebottle pricetag timepricetag choice timechoice origami timeorigami) reg characters money timemoney bottle timebottle pricetag timepricetag choice timechoice origami timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami) reg characters_correct money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money timemoney bottle timebottle pricetag timepricetag choice timechoice origami timeorigami) reg characters_correct money timemoney bottle timebottle pricetag timepricetag choice timechoice origami timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)

bysort id: gen N = _n
sort N wave2 id

egen m = group(money bottle pricetag choice origami), label
tab m
tab m, nolabel

global i = 0

*Table 2 
foreach var in money bottle pricetag choice origami {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1) 
	randcmdc ((`var') reg characters money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)), treatvars(`var') strata(wave2 Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(id)
	}

forvalues j = 1/10 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in money bottle pricetag choice origami {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1) 
	randcmdc ((`var') reg characters_correct money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)), treatvars(`var') strata(wave2 Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(id)
	}

forvalues j = 1/10 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
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
save results\FisherCondKMP, replace







