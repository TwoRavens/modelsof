
use DatLLLPR.dta, clear
quietly tab id, gen(ID)
drop ID1

global i = 1

*Table 3 
reg donation small_gift large_gift warm_list ID*, 
	estimates store M$i
	global i = $i + 1

reg donation small_gift large_gift warm_small warm_large warm_list ID*, 
	estimates store M$i
	global i = $i + 1

reg donation small_gift large_gift warm_pVCM warm_pLotto ID*, 
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3, robust
test small_gift large_gift warm_small warm_large
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

global i = 1
	
*Table 4 
reg give small_gift large_gift warm_list ID*, 
	estimates store M$i
	global i = $i + 1

reg give small_gift large_gift warm_small warm_large warm_list ID*, 
	estimates store M$i
	global i = $i + 1

reg give small_gift large_gift warm_pVCM warm_pLotto ID*, 
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3, robust
test small_gift large_gift warm_small warm_large
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)
	
gen Order = _n
mata Y = st_data(.,("large_gift","small_gift"))
generate double U = .

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort U 
	mata st_store(.,("large_gift","small_gift"),Y)
	quietly replace warm_small = warm_list*small_gift
	quietly replace warm_large = warm_list*large_gift

global i = 1

*Table 3 
quietly reg donation small_gift large_gift warm_list ID*, 
	estimates store M$i
	global i = $i + 1

quietly reg donation small_gift large_gift warm_small warm_large warm_list ID*, 
	estimates store M$i
	global i = $i + 1

quietly reg donation small_gift large_gift warm_pVCM warm_pLotto ID*, 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3, robust
if (_rc == 0) {
	capture test small_gift large_gift warm_small warm_large
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}

global i = 1
	
*Table 4 
quietly reg give small_gift large_gift warm_list ID*, 
	estimates store M$i
	global i = $i + 1

quietly reg give small_gift large_gift warm_small warm_large warm_list ID*, 
	estimates store M$i
	global i = $i + 1

quietly reg give small_gift large_gift warm_pVCM warm_pLotto ID*, 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3, robust
if (_rc == 0) {
	capture test small_gift large_gift warm_small warm_large
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
save results\FisherSuestLLLPR, replace



