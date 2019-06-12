
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

drop _all
svmat double F
save results/SuestLLLPR, replace

