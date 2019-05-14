*******************
***TABLE 5 PANEL A
*******************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using Table5, replace

*COLUMNS 1 AND 2

use main_part2_1, clear

	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' meanprice minpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using tab5A.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local replace
	}


*COLUMNS 3 AND 4

use main_part2_2, clear

	local replace append
	foreach var of varlist toilethouse mud { 
	xi: reg `var' meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using  tab5A.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local append
	}


*******************
***TABLE 5 PANEL B
*******************

*COLUMNS 1 AND 2

use main_part2_1, clear

keep if meanprice!=. & minpriceh!=.

	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' soldpc adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 soldpc using tab5B.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local replace
	}
	

*COLUMNS 3 AND 4


use main_part2_2, clear

keep if meanprice!=. & minpriceh!=.

	local replace append
	foreach var of varlist toilethouse mud { 
	xi: reg `var' soldpc lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 soldpc using  tab5B.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local append
	}

log close
