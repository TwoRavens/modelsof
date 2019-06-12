
****************************************
****************************************

**************************************

use DatKMP, clear

*Table 2 

global i = 1

reg characters money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1
reg characters money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1
reg characters_correct money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1
reg characters_correct money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1

*dropping colinear variables

suest M1 M2 M3 M4, cluster(id)
test money bottle pricetag choice origami 
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

bysort id: gen N = _n
sort N wave2 id
global N = 139
mata Y = st_data((1,$N),("money","bottle","pricetag","choice","origami")) 
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.)
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

global i = 0
quietly reg characters money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1
quietly reg characters money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1
quietly reg characters_correct money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1
quietly reg characters_correct money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4, cluster(id)
if (_rc == 0) {
	capture test money bottle pricetag choice origami 
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
save results\FisherSuestKMP, replace




