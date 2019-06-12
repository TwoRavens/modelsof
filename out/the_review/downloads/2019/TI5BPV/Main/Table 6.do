*******************
***TABLE 5 PANEL A
*******************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using Table6, replace

use main_part2_1, clear

keep if border==1

*COLUMNS 1 AND 2

	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' meanprice minpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using tab6A.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local replace
	}

use main_part2_2, clear

keep if border==1

*COLUMNS 3 AND 4

	local replace append
	foreach var of varlist toilethouse mud { 
	xi: reg `var' meanprice minpriceh lz suitindex ldistlima centerxgd centerygd if border==1, cluster(provincia)
	outreg2 meanprice minpriceh using  tab6A.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local append
	}


*******************
***TABLE 5 PANEL B
*******************


use main_part2_1, clear

keep if border==1

keep if  meanprice!=. & minpriceh!=.

*COLUMNS 1 AND 2
	
	local replace replace
	foreach var of varlist lhhequiv schoolyears { 
	xi: reg `var' soldpc adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 soldpc using tab6B.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust))
	local replace
	}


use main_part2_2, clear

keep if border==1

keep if  meanprice!=. & minpriceh!=.

*COLUMNS 3 AND 4

	local replace append
	foreach var of varlist toilethouse mud { 
	reg `var' soldpc lz suitindex ldistlima centerxgd centerygd if border==1, cluster(provincia)
	outreg2 soldpc using tab6B.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Clusters", e(N_clust)) addtext(District FE, Yes, Year FE, Yes)
	local append
	}

log close
