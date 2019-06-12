
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster') `robust'
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

use DatKMP, clear

matrix F = J(4,4,.)
matrix B = J(30,2,.)

global i = 1
global j = 1

*Table 2 
mycmd (money bottle pricetag choice origami) reg characters money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami) reg characters money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami) reg characters_correct money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami) reg characters_correct money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)

bysort id: gen N = _n
sort N wave2 id
global N = 139
mata Y = st_data((1,$N),("money","bottle","pricetag","choice","origami")) 
generate Order = _n
generate double U = .

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,30,.); ResSE = J($reps,30,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(30,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort wave2 U in 1/$N
	mata st_store((1,$N),("money","bottle","pricetag","choice","origami"),Y)
	sort id N
	foreach j in money bottle pricetag choice origami {
		quietly replace `j' = `j'[_n-1] if id == id[_n-1] 
		}
	foreach j in money bottle pricetag choice origami {
		quietly replace time`j' = `j'*time
		}

global i = 1
global j = 1

*Table 2 
mycmd1 (money bottle pricetag choice origami) reg characters money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd1 (money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami) reg characters money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd1 (money bottle pricetag choice origami) reg characters_correct money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd1 (money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami) reg characters_correct money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..30] = BB[.,1]'; ResSE[`c',1..30] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/30 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherKMP, replace




