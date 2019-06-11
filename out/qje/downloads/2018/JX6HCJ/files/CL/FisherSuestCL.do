
use DatCL, clear

*Table 7
global i = 1
reg attach_to_gr paintings chat oo within_subj, 
	estimates store M$i
	global i = $i + 1

ologit attach_to_gr paintings chat oo within_subj, 
	estimates store M$i
	global i = $i + 1

suest M1 M2, cluster(date)
test paintings chat oo within_subj
matrix F = r(p), r(drop), r(df), r(chi2), 7

egen Session = group(date)
bys Session: gen N = _n
sort N Session
global N = 27
mata Y = st_data((1,$N),("paintings","chat","oo","within_subj"))
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("paintings","chat","oo","within_subj"),Y)
	sort Session N
	foreach j in paintings chat oo within_subj {
		quietly replace `j' = `j'[_n-1] if N > 1
		}

*Table 7
global i = 1
quietly reg attach_to_gr paintings chat oo within_subj, 
	estimates store M$i
	global i = $i + 1

quietly ologit attach_to_gr paintings chat oo within_subj, 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2, cluster(date)
if (_rc == 0) {
	capture test paintings chat oo within_subj
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
save results\FisherSuestCL, replace

