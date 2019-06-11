

use DatKN, clear

*Table 2

global i = 1
foreach Y in Prod_Comm Prod_Points {
	foreach specification in "" "touchtype experiencedatabase concentration" {
		reg `Y' award `specification' if treatment !=2, 
		estimates store M$i
		global i = $i + 1
		}
	}

suest M1 M2 M3 M4, cluster(session1)
test award
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

bysort session1: gen N = _n
sort N session1
global N = 16
mata Y = st_data((1,$N),"award")
generate double U = .
generate Order = _n

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(4,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"award",Y)
	sort session1 N
	quietly replace award = award[_n-1] if session1 == session1[_n-1] 

global i = 1
foreach Y in Prod_Comm Prod_Points {
	foreach specification in "" "touchtype experiencedatabase concentration" {
		quietly reg `Y' award `specification' if treatment !=2, 
		estimates store M$i
		global i = $i + 1
		}
	}

capture suest M1 M2 M3 M4, cluster(session1)
if (_rc == 0) {
	capture test award
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
save results\FisherSuestKN, replace
	
