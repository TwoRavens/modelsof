
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in'
	if (_rc == 0) {
		estimates store M$i
		foreach var in `newtestvars' {
			global j = $j + 1
			matrix B[1,$j] = _b[`var']
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatKMP, clear

matrix B = J(30,2,.)
global j = 1

*Table 2 
global i = 0
mycmd (money bottle pricetag choice origami) reg characters money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami) reg characters money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami) reg characters_correct money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami) reg characters_correct money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)

quietly suest $M, cluster(id)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)
matrix B2 = B[1,1..$j]

gen Order = _n
sort id Order
gen N = 1
gen Dif = (id ~= id[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop id
	rename obs id

*Table 2 
global i = 0
mycmd (money bottle pricetag choice origami) reg characters money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami) reg characters money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami) reg characters_correct money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami) reg characters_correct money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)

capture suest $M, cluster(id)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B2)*invsym(V)*(B[1,1..$j]-B2)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
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
save results\OBootstrapSuestKMP, replace

erase aa.dta
erase aaa.dta



