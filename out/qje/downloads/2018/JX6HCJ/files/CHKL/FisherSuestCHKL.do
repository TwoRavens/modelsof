
use DatCHKL, clear

*Table 7 

global i = 1
tobit post_rating dumconf dumnetb pre_rating, ll 
	estimates store M$i
	global i = $i + 1
	
tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
	estimates store M$i
	global i = $i + 1

tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3
test dumconf dumnetb
matrix F = r(p), r(drop), r(df), r(chi2), 7

generate N = _n
sort special N
global N = 381
mata Y = st_data((1,$N),("dumconf","dumnetb","expcondition"))
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("dumconf","dumnetb","expcondition"),Y)

global i = 1
quietly tobit post_rating dumconf dumnetb pre_rating, ll 
	estimates store M$i
	global i = $i + 1
	
quietly tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
	estimates store M$i
	global i = $i + 1

quietly tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3
if (_rc == 0) {
	capture test dumconf dumnetb
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 7)
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
save results\FisherSuestCHKL, replace



