global cluster = ""

use DatLLLPR.dta, clear

global i = 1
global j = 1

*Table 3 
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_list, absorb(id)
mycmd (small_gift large_gift warm_small warm_large) areg donation small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id)
	
*Table 4 
mycmd (small_gift large_gift) areg give small_gift large_gift warm_list, absorb(id)
mycmd (small_gift large_gift warm_small warm_large) areg give small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd (small_gift large_gift) areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id)
	
